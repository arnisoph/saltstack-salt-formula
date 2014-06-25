{% from "salt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt_minion:
{% if datamap.minion.pkgs|length > 0 %}
  pkg:
    - installed
    - pkgs: {{ datamap.minion.pkgs }}
    - require_in:
      - service: salt_minion
{% endif %}
  service:
    - running
    - name: {{ datamap.minion.service.name }}
    - enable: {{ datamap.minion.service.enable }}
    - watch:
      - file: /etc/salt/minion
    - require:
      - file: /etc/salt/minion

/etc/salt/minion:
  file:
    #- serialize
    #- dataset:
    #     datamap['minion']['config']|default({})
    #- formatter: YAML
    - managed
    - mode: 600
    - user: root
    - group: root
    - contents_pillar: salt:lookup:minion:config
