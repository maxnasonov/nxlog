#
# Cookbook Name:: nxlog
# Resouce:: log_destination
#
# Copyright (C) 2014 Simon Detheridge
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

actions :create, :delete
default_action :create

attribute :name, name_attribute: true, kind_of: String, required: true

# global parameters
attribute :input_module, kind_of: String, required: true,
                         equal_to: %w(xm_syslog xm_gelf xm_fileop
                                      xm_multiline)
attribute :exec, kind_of: [String, Array]

# xm_multiline
attribute :headerline, kind_of: String

