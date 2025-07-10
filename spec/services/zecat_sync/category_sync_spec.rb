# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ZecatSync::CategorySync do
  let(:zecat_country) { 'Chile' }
  let(:category_hash) { { name: 'Cat1', description: 'Desc' } }
  let(:local_category) do
    double(
      'Category',
      # woocommerce_api_id: nil,
      # category_hash: category_hash,
      update: true,
      destroy!: true
    )
  end

  let(:zecat_category) do
    { 'id' => '126', 'description' => '2025 Día del trabajador', 'highlighted' => false,
      'icon_url' => 'https://images-cdn.zecat.cl/categories/ic_Especiales3.svg',
      'icon_active_url' => '',
      'marketing_video' => '', 'marketing_imagen' => '', 'marketing_text' => '',
      'url' => '/dia_del_trabajador', 'wepod' => false,
      'meta' => 'Productos promocionales de alta calidad para el día del trabajador con el logo de tu empresa y al mejor precio por mayor. Líderes en merchandising corporativo.',
      'title' => '2025 Día del trabajador', 'show' => false, 'kit_family' => false,
      'kits_related' => false, 'fgp' => {}, 'products_related' => true, 'discount' => true,
      'logged_out_desktop_banner_image_url' => 'https://zecat-user-images-cl.s3.amazonaws.com/zecat-families-banners/TrabajadorBannerscategorias2500x200pxENDUSER-1742996690.webp',
      'logged_out_mobile_banner_image_url' => 'https://zecat-user-images-cl.s3.amazonaws.com/zecat-families-banners/lTrabajadorBannerscategorias954x200pxENDUSER-1742996704.webp',
      'logged_out_banner_redirect_url' => nil,
      'logged_in_desktop_banner_image_url' => 'https://zecat-user-images-cl.s3.amazonaws.com/zecat-families-banners/lTrabajadorBannerscategorias2500x200pxPARTNER-1742996695.webp',
      'logged_in_mobile_banner_image_url' => 'https://zecat-user-images-cl.s3.amazonaws.com/zecat-families-banners/elTrabajadorBannerscategorias954x200pxPARTNER-1742996711.webp',
      'logged_in_banner_redirect_url' => 'https://bit.ly/CL-Dia-del-Trabajador-2025-editables',
      'attributes' => []
    }
  end

  before do
    stub_const('Category', Class.new)
    allow(Category).to receive(:find_by).and_return(nil)
    allow(Category).to receive(:new).and_return(local_category)
    allow(local_category).to receive(:update)
    allow(local_category).to receive(:destroy!)
  end

  subject { described_class.new(zecat_country) }

  # describe '#iterate_categories_and_sync' do
  #   it 'calls Chile Zecat API once and saves the response with VCR', :vcr do
  #     # This assumes your implementation fetches categories from the Chile Zecat API
  #     # and that the cassette will be saved as 'zecat/chile_categories'
  #     expect_any_instance_of(ZecatSync::CategorySync).to receive(:sync_category_with_woocommerce).at_least(:once)
  #     VCR.use_cassette('zecat/chile_categories') do
  #       subject.iterate_categories_and_sync
  #     end
  #   end
  # end

  let(:present_interaction_stream) do
    JSON.parse(file_fixture('zecat/chile_categories').read)
  end

  context 'when zecat_country is Chile' do
    let(:zecat_country) { 'Chile' }

    describe '#iterate_categories_and_sync' do
      it 'calls sync_category_with_woocommerce for each visible category using VCR', :vcr do
        expect_any_instance_of(ZecatSync::CategorySync).to receive(:sync_category_with_woocommerce).at_least(:once)
        VCR.use_cassette('zecat/chile_categories') do
          byebug
          # Simulate fetching categories from Zecat API
          # allow(CountrySelection).to receive(:zecat_class_name).with(zecat_country).and_return(
          #   double(Families: double(categories: [zecat_category]))
          # )
          # expect(subject).to receive(:sync_category_with_woocommerce).with(local_category, category_hash)
          subject.iterate_categories_and_sync
        end
      end

      # it 'skips categories with show: false using VCR', :vcr do
      #   VCR.use_cassette('zecat/categories_with_hidden') do
      #     hidden_category = { 'id' => 2, 'name' => 'Hidden', 'show' => false }
      #     allow(CountrySelection).to receive(:zecat_class_name).and_return(
      #       double(Families: double(categories: [zecat_category, hidden_category]))
      #     )
      #     expect(subject).to receive(:sync_category_with_woocommerce).once
      #     subject.iterate_categories_and_sync
      #   end
      # end
    end
  end

  describe '#find_or_create_local_category' do
    let(:zecat_country) { 'Chile' }
    let(:zecat_id) { 1 }

    context 'when the category exists' do
      it 'returns the found category' do
        allow(Category).to receive(:find_by).with(zecat_id: zecat_id, country: zecat_country).and_return(local_category)
        result = subject.find_or_create_local_category(zecat_id, category_hash)
        expect(result).to eq(local_category)
      end
    end

    context 'when the category does not exist' do
      it 'creates and returns a new category' do
        allow(Category).to receive(:find_by).with(zecat_id: zecat_id, country: zecat_country).and_return(nil)
        expect(Category).to receive(:new).with(hash_including(name: 'Cat1', description: 'Desc', zecat_id: zecat_id,
                                                              country: zecat_country)).and_return(local_category)
        result = subject.find_or_create_local_category(zecat_id, category_hash)
        expect(result).to eq(local_category)
      end
    end
  end
end

# RSpec.describe ZecatSync::CategorySync do
#   let(:zecat_country) { 'Chile' }
#   let(:zecat_category) { { 'id' => 1, 'name' => 'Cat1', 'description' => 'Desc', 'show' => true } }
#   let(:category_hash) { { name: 'Cat1', description: 'Desc' } }
#   let(:local_category) { instance_double(Category, woocommerce_api_id: nil, category_hash: category_hash, update: true, destroy!: true) }
#   # let(:woocommerce_category) { { 'id' => 123, 'name' => 'Cat1', 'description' => 'Desc', 'success?' => true } }

#   before do
#     stub_const('CountrySelection', Module.new)
#     stub_const('EntityGeneration', Module.new)
#     stub_const('Category', Class.new)

#     allow(Category).to receive(:find_by).and_return(nil)
#     allow(Category).to receive(:new).and_return(local_category)
#     allow(EntityGeneration).to receive_message_chain(:Categories, :category_hash).and_return(category_hash)
#   end

#   subject { described_class.new(zecat_country) }

#   context 'when zecat_country is Chile' do
#     let(:zecat_country) { 'Chile' }

#     describe '#iterate_categories_and_sync' do
#       it 'calls sync_category_with_woocommerce for each visible category using VCR', :vcr do
#         VCR.use_cassette('zecat/chile_categories') do
#           # Simulate fetching categories from Zecat API
#           allow(CountrySelection).to receive(:zecat_class_name).with(zecat_country).and_return(
#             double(Families: double(categories: [zecat_category]))
#           )
#           expect(subject).to receive(:sync_category_with_woocommerce).with(local_category, category_hash)
#           subject.iterate_categories_and_sync
#         end
#       end

#       it 'skips categories with show: false using VCR', :vcr do
#         VCR.use_cassette('zecat/categories_with_hidden') do
#           hidden_category = { 'id' => 2, 'name' => 'Hidden', 'show' => false }
#           allow(CountrySelection).to receive(:zecat_class_name).and_return(
#             double(Families: double(categories: [zecat_category, hidden_category]))
#           )
#           expect(subject).to receive(:sync_category_with_woocommerce).once
#           subject.iterate_categories_and_sync
#         end
#       end
#     end
#   end
# end
