require 'spec_helper'

describe Guard::Git do
  it 'has a version number' do
    expect(Guard::Git::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
