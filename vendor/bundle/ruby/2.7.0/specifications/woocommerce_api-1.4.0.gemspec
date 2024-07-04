# -*- encoding: utf-8 -*-
# stub: woocommerce_api 1.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "woocommerce_api".freeze
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Claudio Sanches".freeze]
  s.date = "2016-12-14"
  s.description = "This gem provide a wrapper to deal with the WooCommerce REST API".freeze
  s.email = "claudio@automattic.com".freeze
  s.extra_rdoc_files = ["README.md".freeze, "LICENSE".freeze]
  s.files = ["LICENSE".freeze, "README.md".freeze]
  s.homepage = "https://github.com/woocommerce/wc-api-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "A Ruby wrapper for the WooCommerce API".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<httparty>.freeze, ["~> 0.14", ">= 0.14.0"])
    s.add_runtime_dependency(%q<json>.freeze, ["~> 2.0", ">= 2.0.0"])
  else
    s.add_dependency(%q<httparty>.freeze, ["~> 0.14", ">= 0.14.0"])
    s.add_dependency(%q<json>.freeze, ["~> 2.0", ">= 2.0.0"])
  end
end
