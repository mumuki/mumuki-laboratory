module Laboratory::Event
  [Book, Topic, Guide].each do |it|
    define_handler("#{it.name}Changed") do |data|
      it.import! data[:slug]
    end
  end
end
