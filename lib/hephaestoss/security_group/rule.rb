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

require_relative '../configurable'

module Hephaestoss
  class SecurityGroup
    # A class representing a single security group rule with protocols, ports,
    # and CIDrs. Configurable attributes for this class include:
    #
    #   * `protocol` - e.g. 'tcp' or 'icmp'
    #   * `port` - e.g. 22, 443, or 'all'
    #   * `from_port` - Instead of a single port, define an inclusive range
    #   * `to_port` - Instead of a single port, define an inclusive range
    #   * `cidr` - The CIDR range to use
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class Rule
      include Configurable

      default_config :protocol, 'tcp'
      default_config :port, nil
      default_config :from_port do |rule|
        rule.port == 'all' ? 0 : rule[:port]
      end
      default_config :to_port do |rule|
        rule.port == 'all' ? 65_535 : rule[:port]
      end
      default_config :cidr, nil

      exclusive_config :port, :from_port
      exclusive_config :port, :to_port

      required_config :from_port
      required_config :to_port
      required_config :cidr

      #
      # Represent the object as a Hash, parsing the simplified configuration
      # values of the class into ones recognizable as an AWS rule.
      #
      # @return [Hash] an AWS-formatted ingress rule hash
      #
      def to_h
        {
          CidrIp: cidr,
          FromPort: from_port,
          ToPort: to_port,
          IpProtocol: protocol
        }
      end
    end
  end
end
