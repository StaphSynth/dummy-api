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
