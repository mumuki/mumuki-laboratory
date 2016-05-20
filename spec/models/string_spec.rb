require 'spec_helper'

describe String do
  describe 'markdown_paragraphs' do
    it { expect("hello\nworld !\n\nbye bye".markdown_paragraphs).to eq ["hello\nworld !", 'bye bye'] }
    it { expect("hello\nworld !\n \nbye bye".markdown_paragraphs).to eq ["hello\nworld !", 'bye bye'] }
    it { expect("hello\nworld !\n \n\nbye bye".markdown_paragraphs).to eq ["hello\nworld !", 'bye bye'] }
  end
end