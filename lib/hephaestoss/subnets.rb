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

require 'json'
require_relative 'configurable'

module Hephaestoss
  # A singleton class used to store and look up information about subnets and
  # the IP ranges that reside in them. The Subnets class needs to be configured
  # with a `path` attribute, pointing to a JSON file that defines recognized
  # subnets, e.g.:
  #
  #   {
  #     "all": ["0.0.0.0/0"]
  #   }
  #
  # @author Jonathan Hartman <jonathan.hartman@socrata.com>
  class Subnets
    include Configurable

    default_config :path, File.expand_path('../../../data/subnets.json',
                                           __FILE__)

    required_config :path

    class << self
      #
      # Provide subnet lookups as index calls on the class.
      #
      # @param [String] the subnet name to look up
      # @param [Symbol] the subnet name to look up
      #
      # @return [Array] the CIDR ranges for that subnet
      #
      def [](subnet)
        to_h[subnet.to_sym]
      end

      #
      # Return a hash representation of the known subnets.
      #
      # @return [Hash] the class' subnets and CIDR ranges
      #
      def to_h
        mapping
      end

      #
      # Read in and save the JSON file after completing all other configuration.
      #
      # (see Hephaestoss::Configurable.configure!)
      #
      def configure!(config = {})
        super
        @mapping = JSON.parse(File.open(@config[:path]).read,
                              symbolize_names: true)
      end

      private

      attr_reader :mapping
    end
  end
end
