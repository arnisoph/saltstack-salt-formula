#!jinja|yaml

{% from "salt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt_syndic:
  pkg:
    - installed
    - pkgs: {{ datamap.syndic.pkgs|default(['salt-syndic']) }}
  service:
    - running
    - name: {{ datamap.syndic.service.name|default('salt-syndic') }}
    - enable: {{ datamap.syndic.service.enable|default(True) }}
