{% from "salt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt-minion:
  pkg:
    - installed
    - pkgs:
{% for pkg in datamap['minion']['pkgs'] %}
      - {{ pkg }}
{% endfor %}
  service:
    - running
    - name: {{ datamap['minion']['service']['name'] }}
    - enable: {{ datamap['minion']['service']['enable'] }}
    - watch:
      - file: /etc/salt/minion
    - require:
      - pkg: salt-minion
      - file: /etc/salt/minion

/etc/salt/minion:
  file:
    - serialize
    - dataset:
        {{ datamap['minion']['config']|default({}) }}
    - formatter: YAML
    - mode: 600
    - user: root
    - group: root
    - require:
      - pkg: salt-minion
