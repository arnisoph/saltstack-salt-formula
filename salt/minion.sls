#!jinja|yaml

{% from "salt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt_minion:
{% if datamap.minion.pkgs|length > 0 %}
  pkg:
    - installed
    - pkgs: {{ datamap.minion.pkgs|default(['salt-minion']) }}
    - require_in:
      - service: salt_minion
{% endif %}
  service:
    - running
    - name: {{ datamap.minion.service.name|default('salt-minion') }}
    - enable: {{ datamap.minion.service.enable|default(True) }}
    - watch:
      - file: /etc/salt/minion
  file:
    - serialize
    - name: /etc/salt/minion
    - dataset: {{ datamap.minion.config|default({})|json }}
    - formatter: JSON
    - mode: 600
    - user: root
    - group: root
