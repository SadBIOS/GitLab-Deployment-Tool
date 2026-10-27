external_url 'http://IPIPIP_PIPIPI'

gitlab_rails['gravatar_enabled'] = false
gitlab_rails['usage_ping_enabled'] = false
gitlab_rails['version_check_enabled'] = false
gitlab_rails['smtp_enable'] = false
gitlab_rails['db_pool'] = 12

puma['worker_processes'] = 2
puma['min_threads'] = 2
puma['max_threads'] = 8
puma['exporter_enabled'] = false

sidekiq['concurrency'] = 10
sidekiq['metrics_enabled'] = false

prometheus_monitoring['enable'] = false
prometheus['enable'] = false
alertmanager['enable'] = false
gitlab_exporter['enable'] = false
node_exporter['enable'] = false
redis_exporter['enable'] = false
postgres_exporter['enable'] = false
gitlab_workhorse['prometheus_listen_addr'] = ''

gitlab_kas['enable'] = false

postgresql['max_connections'] = 80
postgresql['shared_buffers'] = '4GB'
postgresql['work_mem'] = '16MB'
postgresql['maintenance_work_mem'] = '256MB'
postgresql['effective_cache_size'] = '10GB'
postgresql['checkpoint_completion_target'] = 0.9
postgresql['min_wal_size'] = '1GB'
postgresql['max_wal_size'] = '4GB'
postgresql['statement_timeout'] = '30s'
postgresql['max_locks_per_transaction'] = 1024

gitlab_rails['env'] = {
  'MALLOC_CONF' => 'dirty_decay_ms:1000,muzzy_decay_ms:1000'
}

gitaly['env'] = {
  'MALLOC_CONF' => 'dirty_decay_ms:1000,muzzy_decay_ms:1000',
  'GITALY_COMMAND_SPAWN_MAX_PARALLEL' => '4'
}
