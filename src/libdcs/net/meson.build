net_headers = []

net_sources = [
  'dcs-net-consumer.vala',
  'dcs-net-enum.vala',
  'dcs-net-factory.vala',
  'dcs-net-producer.vala',
  'dcs-net-publisher.vala',
  'dcs-net-replier.vala',
  'dcs-net-requester.vala',
  'dcs-net-router.vala',
  'dcs-net-service-provider.vala',
  'dcs-net-service.vala',
  'dcs-net-subscriber.vala',
  'dcs-net-zmq-client.vala',
  'dcs-net-zmq-service.vala',
]

libdcs_headers += files(net_headers)
libdcs_sources += files(net_sources)

install_headers(net_headers, subdir: join_paths(libdcs_header_subdir, 'net'))
