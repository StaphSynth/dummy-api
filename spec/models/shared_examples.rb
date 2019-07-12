shared_examples :a_format_validator do |attribute, good_form, bad_form|
  attribute_setter = "#{attribute}=".to_sym

  context 'when the format is well formed' do
    before do
      subject.send(attribute_setter, good_form)
      subject.validate
    end

    it "does not include #{attribute.to_s} in validation errors" do
      expect(subject.errors.include?(attribute)).to be_falsey
    end
  end

  context 'when the format is malformed' do
    before do
      subject.send(attribute_setter, bad_form)
      subject.validate
    end

    it "includes #{attribute.to_s} in validation errors" do
      expect(subject.errors.include?(attribute)).to be_truthy
    end
  end
end

shared_examples :serializable_record do
  describe '#to_json' do
    let(:model_name) { subject.class.name }
    let(:model_constant) { model_name.safe_constantize }
    let(:serializer_constant) do
      "#{model_name}Serializer".safe_constantize
    end
    let(:serialized_object) do
      JSON.generate({
        attr1: model_name,
        attr2: 42,
        attr3: false
      })
    end
    let(:serializer) { double(serialized_json: serialized_object) }

    before do
      allow(serializer_constant)
        .to receive(:new).with(model_constant).and_return(serializer)
    end

    it 'returns itself serialized in JSON' do
      expect(subject.to_json).to eq(serialized_object)
    end
  end
end
