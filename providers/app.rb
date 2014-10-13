#
# Cookbook Name:: bundler
# Provider:: app
#
# Copyright 2013, Thomas Boerger
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

require "chef/dsl/include_recipe"
include Chef::DSL::IncludeRecipe

action :install do
  if root.directory? and gemfile.file?
    execute "bundler_install_#{root.to_s.gsub("/", "_")}" do
      command "bundle install #{new_resource.params}"
      cwd root.to_s
      action :run

      user new_resource.user
      group new_resource.group || new_resource.user

      # environment(
      #   "HOME" => root.to_s
      # )
    end

    new_resource.updated_by_last_action(true)
  end
end

action :update do
  if root.directory? and gemfile.file?
    execute "bundler_update_#{root.to_s.gsub("/", "_")}" do
      command "bundle update"
      cwd root.to_s
      action :run

      user new_resource.user
      group new_resource.group || new_resource.user

      # environment(
      #   "HOME" => root.to_s
      # )
    end

    new_resource.updated_by_last_action(true)
  end
end

protected

def root
  Pathname.new new_resource.root
end

def gemfile
  root.join("Gemfile")
end