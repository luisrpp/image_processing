# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImageProcessing do
  it 'has a version number' do
    expect(ImageProcessing::VERSION).not_to be nil
  end
end
