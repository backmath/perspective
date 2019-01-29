# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

[ ] Adds a domain store with save, find, delete for identifiable structs



Order of operations:
  <!-- - Generate Action PID from Request (holds action data, user, callback for success/failures)
    ActionRequest
      - ID: "8c8a2529-2fcb-42d1-814d-c44723dd85db" (auto generated)
      - Host: "com.walker-technologies.net" (from request)
      - Date: "2018-12-06T18:18:47.229574Z" (auto generated)
      - Requestor: { } (From authorization token)
      - Action: "Add A Job"
      - Data: { } -->
  - Add to Action Queue (Producer)
  - Authorize Action (Producer-Consumer)
  - Validate Action Syntax (Producer-Consumer)
  - Synchronize across shard key (Producer-Consumer)
  - Check for synchronization lock / Synchronize across shard key (Timing/Synchronization happens here)
    - If locked, throw back (or hold?) in queue
    - If unlocked, proceed
  - Lock Shard
  - Validate Domain Semantics (Producer-Consumer)
  - Add to Action Log (Producer-Consumer)
  - Update Domain Store (To be reactionary, it must come after adding to the event log)
  - Unlock Shard

  Reactor
    - Find by shard key, or create
    - Authorize Action
    - Validate Syntax
    - Validate Semantics




