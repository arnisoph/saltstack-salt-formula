include:
  - salt

{% from "salt/map.jinja" import salt_map with context %}

salt-master:
  pkg:
    - installed
    - pkgs:
{% for pkg in salt_map['master']['pkgs'] %}
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
    - managed
    - source: salt://salt/files/etc/salt/master
    - mode: '0600'
    - user: root
    - group: root
    - template: jinja
    - require:
      - pkg: salt-master
