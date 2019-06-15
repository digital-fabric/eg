# frozen_string_literal: true

require 'modulation/gem'

export_default :EG

# EG object creation functionality
module EG
  RE_CONST  = /^[A-Z]/.freeze
  RE_ATTR   = /^@(.+)$/.freeze

  # Creates an object from its prototype hash
  # @param hash [Hash] prototype hash
  # @return [Module] created object
  def self.call(hash)
    Module.new.tap do |m|
      s = m.singleton_class
      hash.each do |k, v|
        if k =~ RE_CONST
          m.const_set(k, v)
        elsif k =~ RE_ATTR
          m.instance_variable_set(k, v)
        elsif v.respond_to?(:to_proc)
          s.define_method(k) { |*args| instance_exec(*args, &v) }
        else
          s.define_method(k) { v }
        end
      end
    end
  end

  def self.to_proc
    ->(hash) { EG.call(hash) }
  end
end
