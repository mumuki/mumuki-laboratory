namespace :comments do
  task listen: :environment do

    config ||= YAML.load(ERB.new(File.read(File.expand_path '../../../config/rabbit.yml', __FILE__)).result).
        with_indifferent_access[ENV['RACK_ENV'] || 'development']

    conn = Bunny.new(host: config[:host],
              port: config[:port],
              user: config[:user],
              password: config[:password])

    conn.start

    ch   = conn.create_channel
    q    = ch.queue("comments", :durable => true)

    ch.prefetch(1)

    begin
      q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        comment_data = JSON.parse(body).first

        comment_data = Comment.parse_json(comment_data)

        Book.find_by(name: comment_data.delete('tenant')).switch!

        Comment.create! comment_data

        ch.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt => _
      conn.close
    end
  end
end
