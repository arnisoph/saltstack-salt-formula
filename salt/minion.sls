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

{% for c in datamap.minion.config.manage|default([]) %}
  {% set f = datamap['minion']['config'][c]|default({}) %}
salt_minion_config_{{ c }}:
  file:
    - {{ f.ensure|default('serialize') }}
    - name: {{ f.path }}
  {% if 'template_path' in f %}
    - source: {{ f.template_path }}
  {% endif %}
    - mode: {{ f.mode|default(644) }}
    - user: root
    - group: root
  {% if 'template' in f %}
    - template: {{ f.template }}
  {% endif %}
  {% if 'contents' in f %}
    - contents: {{ f.contents }}
  {% endif %}
  {% if 'dataset_pillar' in f %}
    - dataset_pillar: {{ f.dataset_pillar }}
  {% endif %}
  {% if f.ensure|default('serialize') == 'serialize' %}
    - formatter: {{ f.formatter|default('json') }}
  {% endif %}
    - watch_in:
      - service: salt_minion
{% endfor %}
