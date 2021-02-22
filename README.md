# EBS Volume Module

This module creates EBS volumes and optionally a DLM policy for automated
snapshots. The module requires:
- a name to use in tagging;
- a list of availability zones; and 
- disk size.

Optional parameters configure the following:
- number of volumes per availability zone;
- disk type;
- disk IOPs (for specific types);
- encryption and key;
- snapshots to launch volumes from; and
- backup period and retention.
