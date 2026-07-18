# Reading performance guide

## What the host prepares

For comic/archive books, the host must inspect the archive, decompress image data,
generate thumbnails, prepare requested pages and populate the cache. The browser then
downloads and decodes those images.

That is why the host processor often matters more than the raw disk specification.

## Choose the host for the experience you want

| Priority | Recommended host |
| --- | --- |
| Smoothest native-client reading | Modern Mac or PC |
| Always-on, low-power personal library | NAS |
| Free browser library and reader | Docker on NAS, Mac, PC or Linux |

A NAS remains useful even when it is slower. It trades peak speed for availability,
low power use and centralized storage.

## HDD, SSD and NVMe cache

- HDD is supported, but cold random access may be slower.
- SSD can reduce storage latency.
- NVMe cache can help workloads that the NAS cache policy retains.
- None of these removes the CPU cost of archive decompression and image preparation.

## Improve NAS reading

1. Keep `/cache` on fast storage when possible.
2. Preserve `/cache` across container restarts.
3. Avoid simultaneous heavy NAS jobs such as RAID scrubbing, media transcoding and
   large backups while testing.
4. Refresh after copying books so indexing work does not first happen during reading.
5. Use a wired NAS connection and strong local Wi-Fi for the reading device.
6. Test the second read of the same pages separately from the first cold read.
7. Check NAS CPU, memory and volume activity when pauses occur.

Continuous mode intentionally loads a bounded set of nearby pages rather than the
entire book at once. This controls memory and network use, but it means scrolling
quickly can catch up to page preparation on a lower-power NAS.
