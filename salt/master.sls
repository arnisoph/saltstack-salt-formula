#!jinja|yaml

{% from "salt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt_master:
  pkg:
    - installed
    - pkgs: {{ datamap.master.pkgs|default(['salt-master']) }}
  service:
    - running
    - name: {{ datamap.master.service.name|default('salt-master') }}
    - enable: {{ datamap.master.service.enable|default(True) }}
    - watch:
      - file: /etc/salt/master
  file:
    - serialize
    - name: /etc/salt/master
    - dataset: {{ datamap.master.config|default({})|json }}
    - formatter: JSON
    - mode: 600
    - user: root
    - group: root
