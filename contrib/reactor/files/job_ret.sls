{% if data['id'] != salt['grains.get']('fqdn') or data['fun'] != 'cmd.run' %}
log_minion_new_job:
  local.cmd.run:
    - name: log minion job
    - tgt: 'master*'
    - arg:
      - 'echo "[{{ data['id'] }}][ret job       ] A minion just executed {{ data['fun'] }}. ({{ tag }})" >> /tmp/salt.reactor.log'
{% endif %}
