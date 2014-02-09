{% from "salt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('salt:lookup')) %}

include:
  - salt

salt-master:
  pkg:
    - installed
    - pkgs:
{% for pkg in datamap['master']['pkgs'] %}
      - {{ pkg }}
{% endfor %}
  service:
    - running
    - watch:
      - file: /etc/salt/master
    - require:
      - file: /etc/salt/master

/etc/salt/master:
  file:
    - serialize
    - dataset: {% if datamap['master']['config'] is defined %}{{ datamap['master']['config'] }}{% endif %}
    - formatter: YAML
    - mode: '0600'
    - user: root
    - group: root
    - require:
      - pkg: salt-master
