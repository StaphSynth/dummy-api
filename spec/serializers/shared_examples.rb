shared_examples :a_serializer do |resource, attributes|
  describe 'meta' do
    it "renders the id, type, attributes and relationships of #{resource}" do
      meta_list = subject[:data].map(&:first)

      expect(meta_list).to eq(%i[id type attributes relationships])
    end

    it "renders the type as :#{resource}" do
      expect(subject[:data][:type]).to eq(resource)
    end
  end

  describe 'attributes' do
    it "renders the attributes of #{resource}" do
      attribute_list = subject[:data][:attributes].map(&:first)

      expect(attribute_list).to eq(attributes)
    end
  end
end
