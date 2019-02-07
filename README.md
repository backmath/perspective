# Perspective: An Event Sourcing Framework

## A  Perspective on Software

In life there are things, all kinds of new things.

Some things are found here, some things happen there.

Most things don't matter to everyone, they just matter to someone.

These things are data and what happens to them, too.

We identify things and name them, we track and observe them.

Then we see that things can happen to other things, too.

---

## The Domain Pool

As in life and so in our systems, we need to identify things uniquely. These identifiable somethings represent the canonical state for the application, and consequently the canonical state of our domain. These identifiable somethings are called **domain nodes** and are managed as part of **the domain pool**.

The domain pool is modified by **action request** and may be read by **query request**.

The domain pool uses in-memory processes to store and retrieve data and asynchronously backs up to a semi-permanent system cache. It will also randomly regenerate nodes and compare with cache to help discover any idempotency issues.

From the developer's view, the domain pool is something you save and fetch canonical representations of your domain's state. It should never be modified directly, only by action request. It has the strongest guarantee of consistency within the system.

## Perspectives

Now with our domain pool and its domain nodes, we can create projections off of this state into **perspectives**.  Perspectives are reactionary computations from the domain state. In the case of a financial ledger, each transaction would be represented by a domain node, and the current balance of your ledger would be represented in a **perspective**.

Whenever the domain pool is modified, any perspectives that reference the affected domain nodes will update with the new application data. Perspectives may be read by **query requests**, but can only by modified as a **domain reaction**.

## The Event Store

The event store is the least complex, but most powerful part of the system. It stores the received-order events and backs them up to a long-term, persistent blockchain.

## Changing the System

The beginning point for changing our domain is the action request. An action request includes its data and zero, one, or many references to an identifiable something.

Every change to the system is represented by an identical procedure.

### Action Requests

The domain pool is modified by submitting an **action request**. The domain pool may be updated concurrently across all nodes, so long as each node is updated integrally and sequentially. Many action request enqueued for the same node or set of nodes must be processed sequentially.

If many action request arrive "simultaneously", they can be applied concurrently up to the limits of the hardware and software configuration. However, if many action requests arrive "simultaneously" to modify the same domain node, then th

An action request contains all the information required to process the request.

The type referenced can be any valid string. It must refer back to a set of transformers and processors.

```json
// Example action requests
// Add a todo
{
  "type": "Add ToDo",
  "version": 0,
  "requestID": "request:5629c0cc-4f47-42a3-a1be-71ee16dcf30e",
  "authenticationToken": "9fabcb909:c87b32c26d8ce:0383a21d84abf4",
  "agent":  "user:bbe22817-5205-47d5-bdca-e4d270e13277",
  "data": {
    "title": "Demonstrate an action request"
  }
}

// Add a sub-todo
{
  "type": "Add Sub-ToDo",
  "version": 0,
  "requestID": "request:e008852b-9cbe-4262-bbd1-ad19c4b52de3",
  "authenticationToken": "9fabcb909:c87b32c26d8ce:0383a21d84abf4",
  "agent":  "user:bbe22817-5205-47d5-bdca-e4d270e13277",
  "references": {
    "parent": "todo:469e2610-4949-458e-8b94-6153b2fe17a7"
  },
  "data": {
    "title": "A sub-todo, attached and indendently doable"
  }
}

// Share the todo with two users
{
  "type": "Share ToDo",
  "version": 1,
  "requestID": "request:c15028aa-89da-4f6c-942e-64767b804f7a",
  "authenticationToken": "9fabcb909:c87b32c26d8ce:0383a21d84abf4",
  "agent":  "user:bbe22817-5205-47d5-bdca-e4d270e13277",
  "references": {
    "todo": "todo:469e2610-4949-458e-8b94-6153b2fe17a7",
    "users": [
      "user:bbe22817-5205-47d5-bdca-e4d270e13277",
      "user:574b4455-f547-4348-85aa-c979136a413c"
    ]
  },
  "data": {
    "message": "Hey everyone, here's the todo I was talking about."
  }
}
```

### Domain Events

A domain event is used to transform the all respective domain nodes. It will often contain much of the information found within an action request. It may also include some temporal data that may only be generated at the time of processing, such as timestamps or identifiers.

```json
{
  "type": "ToDo Added",
  "version": 0,
  "agent":  "user:bbe22817-5205-47d5-bdca-e4d270e13277",
  "date": "2019-01-30T21:22:11Z",
  "data": {
    "id": "todo:469e2610-4949-458e-8b94-6153b2fe17a7",
    "title": "Demonstrate an action request"
  }
}

// Add a sub-todo
{
  "type": "Sub-ToDo Added",
  "version": 0,
  "agent":  "user:bbe22817-5205-47d5-bdca-e4d270e13277",
  "date": "2019-01-30T21:23:05Z",
  "references": {
    "parent": "todo:5a80cfc2-65e5-4ba6-9c7e-f5002f8d5906"
  },
  "data": {
    "id": "todo:a477ee03-26e5-4ce4-ad01-4c1ae8258d79",
    "title": "A sub-todo, attached and indendently doable"
  }
}

// Share the todo with two users
{
  "type": "Share ToDo",
  "version": 1,
  "agent":  "user:bbe22817-5205-47d5-bdca-e4d270e13277",
  "references": {
    "todo": "todo:6af49078-17b6-4e5b-8c3d-5a16387bbc8d",
    "users": [
      "user:bbe22817-5205-47d5-bdca-e4d270e13277",
      "user:574b4455-f547-4348-85aa-c979136a413c"
    ]
  },
  "data": {
    "message": "Hey everyone, here's the todo I was talking about."
  }
}
```

### Action Processor

An action processor is responsible for coordinating several procedures with respect to the given action request. Once a processor is next in queue (to be elaborated in the next section), the following are coordinated in sequence:

- The processor fetches the domain nodes for each reference from the domain pool
- The processor authenticates the action
- The processor authorizes the action against each node
- The processor transforms the action into an event
- The event is applied to each domain node
- The domain pool is updated with the domain nodes
- The event store receives the new event.

Once the event store receives the new event, the action request is considered complete.

Should any procedure fail, the the action request is rejected and reports any errors.

Applying events happen AFTER side-effects, if any.
<!-- - Syntatic validation occurs (should be moved to another space, action requests should be assumed to be syntactically correct by this step) -->

### The Processor Queue

Once an action request is recieved, an action processor is created for the request. To ensure sequentiality, each processor is queued according to each referenced domain node. The action processor is added to a keyed queue and may not begin operations until all the processers in queue for that key before it have completed processing. When referencing multiple domain nodes, all processors for the referenced domain nodes must complete processing before the

The referenced somethings are all checked out of the domain pool. The event is applied to each of the referenced identifiable somethings and is checked into the domain. If the event

### Code Organization

Seperate concerns into three categories: data, transformation, supervision and access.


You
Requests:

{
  "type": "BackMath.AddToDo.V0",
  "requestID": "request:e008852b-9cbe-4262-bbd1-ad19c4b52de3",
  "authenticationToken": "9fabcb909:c87b32c26d8ce:0383a21d84abf4",
  "agent":  "user:bbe22817-5205-47d5-bdca-e4d270e13277",
  "references": {
    "parent": "todo:469e2610-4949-458e-8b94-6153b2fe17a7"
  },
  "data": {
    "title": "A sub-todo, attached and indendently doable"
  }
}
