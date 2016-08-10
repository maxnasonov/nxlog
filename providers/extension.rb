#
# Cookbook Name:: nxlog
# Provider:: log_source
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

def whyrun_supported?
  true
end

def config_filename(name)
  "#{Chef::Config[:file_cache_path]}/nxlog.conf.d/30_ext_#{name}.conf"
end

action :create do
  converge_by("Create #{new_resource}") do
    n = new_resource

    # common parameters
    params = []
    params << ['Module', n.module]
    params.push(*[*n.exec].map{ |x| ["Exec", x] }) if n.exec

    # module-specific parameters
    case n.module

    when 'im_multiline'
      params << ['Headerline', n.headerline]

    else
      # nothing to do!
      # TODO: It is better case all possible modules and throw an error here

    end

    # create template with above parameters
    template config_filename(n.name) do
      cookbook 'nxlog'
      source 'resources/extension.conf.erb'

      variables name: n.name,
                params: params

      notifies :restart, 'service[nxlog]', :delayed
    end
  end
end

action :delete do
  converge_by("Delete #{new_resource}") do
    template config_filename(new_resource.name) do
      cookbook new_resource.cookbook_name.to_s
      source 'resources/extension.conf.erb'
      action :delete
      notifies :restart, 'service[nxlog]', :delayed
    end
  end
end
