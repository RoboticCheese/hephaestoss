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

module Hephaestoss
  class Exceptions
    # A custom exception class for a missing required configuration key.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class ConfigMissing < StandardError
      def initialize(key)
        super("`#{key}` config key cannot be nil")
      end
    end

    # A custom exception class for an invalid configuration key.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class InvalidConfig < StandardError
      def initialize(key)
        super("`#{key}` is not a valid config key")
      end
    end

    # A custom exception class for an invalid configuration combination.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    #
    class InvalidConfigCombination < StandardError
      def initialize(keys)
        super("The `#{keys}` config keys are mutually exclusive")
      end
    end
  end
end
