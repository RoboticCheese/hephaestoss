# Encoding: UTF-8
#
# Author:: Jonathan Hartman (<jonathan.hartman@socrata.com>)
#
# Copyright (C) 2015 Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'exceptions'

module Hephaestoss
  # A mixin that other classes can include to implement certain configuration
  # niceties. Based partly on Test Kitchen's Configurable module
  # (https://github.com/test-kitchen/test-kitchen/blob/master/lib/kitchen/
  # configurable.rb), but simplified for use in this application.
  #
  # @author Jonathan Hartman <jonathan.hartman@socrata.com>
  module Configurable
    #
    # Use the .included hook to pull in ClassMethods and make all its methods
    # accessible on the class level.
    #
    def self.included(base)
      base.extend(ClassMethods)
    end

    #
    # Initialize based on a config hash and save it as an instance variable.
    #
    # @param config [Hash] an input hash of config overrides
    #
    def initialize(config = {})
      @config = config || {}
      build_config!
      validate_config!
    end

    #
    # Make config attributes accessible via indices on the object.
    #
    # @param attr [Symbol] the attribute to look up
    #
    # @return [Object] the config item at that attribute key
    #
    def [](attr)
      config[attr]
    end

    #
    # And make each config key also accessible as a method.
    #
    # (see Class#method_missing)
    #
    def method_missing(name, *args, &block)
      config.key?(name) ? config[name] : super
    end

    #
    # Take an input configuration hash and merge it with all config defaults
    # to build a final config hash for the configurable object:
    #
    #   * Error out immediately if an invalid config combination was passed in
    #   * Iterate over every static (non-proc) default value
    #   * Then, yield the configurable object to each default proc (non-static,
    #     potentially derived from earlier default values)
    #
    # @raise [InvalidConfigCombination] if the user attempted to override two
    #                                   mutually exclusive settings
    def build_config!
      self.class.exclusives.each do |es|
        es.combination(2).each do |e1, e2|
          !@config[e1].nil? && !@config[e2].nil? && \
            fail(Exceptions::InvalidConfigCombination, [e1, e2])
        end
      end
      self.class.defaults.each { |k, v| config[k] ||= v unless v.is_a?(Proc) }
      self.class.defaults.each do |k, v|
        config[k] ||= v.call(self) if v.is_a?(Proc)
      end
    end

    #
    # Iterate over any config validation that needs to be done for the built
    # config hash:
    #
    #   * Ensure each config key is a recognized one (listed as a default or
    #     required config item)
    #   * Ensure each required config item is present and non-nil
    #
    # @raise [ConfigError] if a config key validation fails
    #
    def validate_config!
      config.each do |k, _|
        if !(self.class.defaults.keys + self.class.required).include?(k)
          fail(Exceptions::InvalidConfig, k)
        end
      end
      self.class.required.each do |r|
        fail(Exceptions::ConfigMissing, r) if config[r].nil?
      end
    end

    #
    # Return the opject's internal configuration hash.
    #
    # @return [Hash] a configuration Hash
    #
    def config
      @config ||= {}
    end

    # The subset of methods to be used, DSL-style, in a Configurable class.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    module ClassMethods
      #
      # Declare a set of config keys that are mutually exclusive and cannot
      # be overridden in the same Configurable object.
      #
      # @param [Array<Symbol>] an array of config keys
      #
      def exclusive_config(*args)
        exclusives << args
      end

      #
      # Declare a config key that is required (i.e. must be non-nil) for use
      # at validation time.
      #
      # @param key [Symbol] a required configuration key
      #
      def required_config(key)
        required << key
      end

      #
      # Declare a default value for a specified config key.
      #
      # @param key [Symbol] a configuration key to assign a default to
      # @param value [Object, nil] the value to assign to this config key
      # @param block [Proc] a block to yield the object to
      #
      def default_config(key, value = nil, &block)
        defaults[key] = block_given? ? block : value
      end

      #
      # An array for holding sets of config keys that are mutually exclusive
      # and cannot both be set by the user.
      #
      # @return [Array<Array>] an array of arrays of config keys
      #
      def exclusives
        @exclusives ||= []
      end

      #
      # An Array in which we can store config keys that are required, for the
      # validation phase to iterate over.
      #
      # @return [Array<Symbol>] a list of config keys
      #
      def required
        @required ||= []
      end

      #
      # A Hash of default configuration keys and their values.
      #
      # @return [Hash] a Hash of defaults
      #
      def defaults
        @defaults ||= {}
      end

      #
      # Provide a class .configure! method for singleton classes that saves
      # an instance of the class in @instance that can then be used by other
      # class methods.
      #
      # @param config [Hash] a configuration Hash
      #
      def configure!(config = {})
        @instance = new(config || {})
      end
      attr_reader :instance
    end
  end
end
