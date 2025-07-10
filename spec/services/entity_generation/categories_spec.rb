require 'spec_helper'

RSpec.describe EntityGeneration::Categories do
  describe '.fill_categories_hash' do
    it 'returns an array of category hashes' do
      categories = [
        { 'description' => 'Cat1', 'meta' => 'Meta1', 'icon_url' => 'http://img.com/1.png', 'url' => '/cat1' },
        { 'description' => 'Cat2', 'meta' => 'Meta2', 'icon_url' => 'http://img.com/2.png', 'url' => nil }
      ]
      result = described_class.fill_categories_hash(categories)
      expect(result).to eq([
        {
          name: 'Cat1',
          description: 'Meta1',
          image: { src: 'http://img.com/1.png' },
          slug: 'cat1'
        },
        {
          name: 'Cat2',
          description: 'Meta2',
          image: { src: 'http://img.com/2.png' }
        }
      ])
    end

    it 'returns an empty array if categories is empty' do
      expect(described_class.fill_categories_hash([])).to eq([])
    end
  end

  describe '.category_hash' do
    context 'when url is present' do
      let(:category) { { 'description' => 'Cat1', 'meta' => 'Meta1', 'icon_url' => 'http://img.com/1.png', 'url' => '/cat1' } }

      it 'returns a hash with slug' do
        expect(described_class.category_hash(category)).to eq(
          name: 'Cat1',
          description: 'Meta1',
          image: { src: 'http://img.com/1.png' },
          slug: 'cat1'
        )
      end
    end

    context 'when url is nil' do
      let(:category) { { 'description' => 'Cat2', 'meta' => 'Meta2', 'icon_url' => 'http://img.com/2.png', 'url' => nil } }

      it 'returns a hash without slug' do
        expect(described_class.category_hash(category)).to eq(
          name: 'Cat2',
          description: 'Meta2',
          image: { src: 'http://img.com/2.png' }
        )
      end
    end

    context 'when url is an empty string' do
      let(:category) { { 'description' => 'Cat3', 'meta' => 'Meta3', 'icon_url' => 'http://img.com/3.png', 'url' => '' } }

      it 'returns a hash without slug' do
        expect(described_class.category_hash(category)).to eq(
          name: 'Cat3',
          description: 'Meta3',
          image: { src: 'http://img.com/3.png' }
        )
      end