# concourse-ical-resource

__Work in progress!__

[![Build Status](https://travis-ci.org/suhlig/concourse-ical-resource.svg?branch=master)](https://travis-ci.org/suhlig/concourse-ical-resource)

[Concourse](https://concourse.ci/ "Concourse Homepage") [resource](https://concourse.ci/implementing-resources.html "Implementing a Resource") for ical feeds.

# Resource Type Configuration

```yaml
resource_types:
  - name: ical-resource
    type: docker-image
    source:
      repository: suhlig/concourse-ical-resource
      tag: latest
```

Example usage:

```yaml
resources:
  - name: runtime-pmc-meetings
    type: icalendar
    source:
      url:  https://www.google.com/calendar/ical/cloudfoundry.org_8ms13q67p9jjeeilng6dosnu50@group.calendar.google.com/public/basic.ics
      range: yesterday
```

# Source Configuration

* `url`: *Required.* The URL of the iCal feed. Anything that can be parsed by the [Icalendar](https://rubygems.org/gems/icalendar) gem should be good.
* `range`: *Optional.* A string expressing a date range, e.g. "yesterday". Defaults to "today".

# Behavior

## `check`: Extract items from the feed

The resource will fetch the iCal feed specified in `url` and will version items by their start and end attributes.

**Example**

A calendar has events scheduled for 10 a.m. - 11 a.m. and 3 p.m. - 3:30 p.m. today. Upon check, the resource will return the version `t9aposkhg5it3ofgmmq0e62vlc_R20161214T223000@google.com`, assuming that this is the `UID` of the 3 p.m. event.

## `in`: Fetch an item from the feed

The resource will select the first item of the feed that has the requested `start`. For each attribute of that item, it writes the attribute value to a file into the destination directory.

**Example**

With the feed in `spec/fixtures/runtime_pmc_meetings.ical`, when asked for the version with a `start` of "`2017-10-03 15:00:00 UTC`", the resource will write the following files to the destination directory:

| File Name     | Content                                                       |
| ------------- | ------------------------------------------------------------- |
| `uid`         | t9aposkhg5it3ofgmmq0e62vlc_R20161214T223000@google.com        |
| `summary`     | Runtime PMC Meeting                                           |
| `start_time`  | 20161214T173000                                               |
| `end_time`    | 20161214T180000                                               |
| `description` | https://meetings.webex.com/collabs/#/meetings/detail?uuid=XYZ |
| `location`    | webex                                                         |

## `out`: Not implemented

There is output from this resource.

# Development

## One-time Setup

```bash
bundle install
```

## Running the Tests

Tests assume you have a running docker daemon:

```bash
bundle exec rake
```

## Docker Image

After a `git push` to the master branch, if the build was successful, Travis [automatically pushes an updated docker image](https://docs.travis-ci.com/user/docker/#Pushing-a-Docker-Image-to-a-Registry).
