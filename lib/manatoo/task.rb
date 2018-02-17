require 'forwardable'
require 'json'
require 'plissken'

module Manatoo
  class Task
    extend Forwardable

    TASK_KEYS = [
      :id,
      :title,
      :data,
      :description,
      :slug,
      :status,
      :weight,
      :duration,
      :labels,
      :finished_at,
      :created_at,
      :due_at,
      :started_at,
      :list_id,
      :users,
    ]

    ATTRIBUTES_STRUCT = Struct.new(*TASK_KEYS)

    attr_reader :attributes, :last_json_response
    delegate TASK_KEYS => :attributes

    def handle_json(json)
      @last_json_response = json
      task_attrs = json['data'].to_snake_keys
      set_attributes_from_hash(task_attrs)
      self
    end

    def set_attributes_from_hash(hash)
      hash.each do |k, v|
        attributes[k] = v
      end
    end

    # list_id, title REQUIRED
    def self.create(list_id:, title:, **attrs)
      url = "tasks"
      resp = Manatoo.post(url, attrs.merge({
          title: title,
          list_id: list_id,
        }))
      json = JSON.parse(resp.body)
      attrs = json['data'].to_snake_keys
      Task.new(attrs, json)
    end

    # task_id REQUIRED
    def self.find(task_id)
      url = "tasks/#{task_id}"
      resp = Manatoo.get(url)
      json = JSON.parse(resp.body)
      attrs = json['data'].to_snake_keys
      Task.new(attrs, json)
    end

    def initialize(data, json)
      @attributes = ATTRIBUTES_STRUCT.new
      set_attributes_from_hash(data)
      @last_json_response = json
      self
    end

    # task_id REQUIRED
    def self.update(task_id, attrs)
      url = "tasks/#{task_id}"
      resp = Manatoo.put(url, attrs)
      JSON.parse(resp.body)
    end

    def update(attrs)
      json = Task.update(id, attrs)
      handle_json(json)
    end

    # task_id, status REQUIRED
    def self.update_status(task_id, status)
      url = "tasks/#{task_id}/status"
      resp = Manatoo.put(url, {
        status: status
      })
      JSON.parse(resp.body)
    end

    def update_status(status)
      json = Task.update_status(id, status)
      handle_json(json)
    end

    # labels should not be empty, should be array
    def self.add_labels(task_id, labels)
      url = "tasks/#{task_id}/labels"
      resp = Manatoo.post(url, {
        labels: labels
      })
      JSON.parse(resp.body)
    end

    def add_labels(labels)
      json = Task.add_labels(id, labels)
      handle_json(json)
    end

    # weight REQUIRED, should be integer
    def self.add_weight(task_id, weight)
      url = "tasks/#{task_id}/weight"
      resp = Manatoo.post(url, {
        weight: weight
      })
      JSON.parse(resp.body)
    end

    def add_weight(weight)
      json = Task.add_weight(id, weight)
      handle_json(json)
    end

    # users should not be empty, should be array
    def self.add_users(task_id, users)
      url = "tasks/#{task_id}/users"
      resp = Manatoo.post(url, {
        users: users
      })
      JSON.parse(resp.body)
    end

    def add_users(users)
      json = Task.add_users(id, weight)
      handle_json(json)
    end

    # users should not be empty, should be array
    def self.remove_users(task_id, users)
      url = "tasks/#{task_id}/users"
      resp = Manatoo.delete(url, {
        users: users
      })
      JSON.parse(resp.body)
    end

    def remove_members(users)
      json = Task.remove_users(id, weight)
      handle_json(json)
    end
  end
end
