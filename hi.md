
Progress Update and Roadmap
============================

- Goal: Design and benchmark lock-free distributed data structures.
- Motivation: Improve throughput and scalability without locks.
- Context: Prototyping with MPI using Python on a single Linux laptop.

<!-- end_slide -->

Key Foundational Papers Studied
===============================

- Michael-Scott Queue (1996): Canonical non-blocking queue CAS logic.
- Mellor-Crummey (1991): Scalable synchronization beyond simple locks.
- Linearizability: Correctness framework for concurrent objects.
- Fraser Epoch-Based Reclamation: Practical lock-free memory management.

<!-- end_slide -->

Key Insights from Papers
=========================

- Lock-free avoids convoying and deadlocks, enabling scalability.
- Memory reclamation is a practical challenge but essential.
- Linearizability is used to verify data structure correctness.
- Algorithms rely on atomic primitives and careful synchronization.

<!-- end_slide -->

Current Status and Environment
==============================

- Thorough reading/notes of foundational lock-free papers.
- Setup: Python with mpi4py, local multi-process support.
- Initial experiments planned with MPI multi-process, lock-free queues.
- Focus: Local emulation for process-level parallelism.

<!-- end_slide -->

Updated Practical Roadmap
==========================

- Implement/test Michael-Scott queue with Python multiprocessing.
- Benchmark: Throughput, latency with many MPI processes.
- Fault injection: Artificial delays, process crash scenarios.
- Optional: Explore MPI one-sided communication (RMA).
- Network simulation: Simple effects tested as time allows.

<!-- end_slide -->

1-Month Research Plan (Next Two Weeks)
======================================

- Days 1-3: Install/test MPI Python. Implement Michael-Scott queue. Run initial benchmarks.
- Days 4-6: Add contention tests, implement basic fault injection, try epoch-based reclamation.
- Days 7-9: Simulate network delays, measure progress/correctness impacts.
- Days 10-12: Try MPI RMA (if feasible). Compare with message-passing baseline results.
- Days 13-15: Compile results, prepare slides, propose next steps.

<!-- end_slide -->

Challenges and Deferred Items
=============================

- RDMA and native C/Rust deferred due to time/resources.
- Large-scale distributed lock-freedom left for future work.
- Focus on practical, measurable goals for this month.

<!-- end_slide -->

What’s Next / Where Help Needed
===============================

- Validating benchmarks as feedback.
- Advice on inject/fault strategies and practical MPI RMA.
- Guidance on best practices for Python lock-free patterns.

<!-- end_slide -->

Thank You / Q&A
===============

