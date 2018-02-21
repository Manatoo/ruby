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

    def handle_snake_cased_json(snake_cased_json)
      # if a user wanted the last_response_json, I assume they would want it
      # in a snake_cased ruby usable fashion
      @last_json_response = snake_cased_json
      task_attrs = @last_json_response['data']
      set_attributes_from_hash(task_attrs)
      self
    end

    def set_attributes_from_hash(hash)
      hash.each do |k, v|
        attributes[k] = v
      end
    end

    # list_id, title REQUIRED
    def self.create(attrs, return_task=false)
      raise ArgumentError.new('Task attributes must be passed in as a Hash') unless attrs.is_a?(Hash)
      raise ArgumentError.new(
        'Both list_id and title must be passed in and not blank'
      ) if attrs[:list_id].nil? or attrs[:list_id].blank? or attrs[:title].nil? or attrs[:title].blank?

      url = "tasks"
      resp = Manatoo.post(url, attrs.merge({
          title: title,
          list_id: list_id,
        }))
      snake_cased_json = JSON.parse(resp.body).to_snake_keys
      attrs = snake_cased_json['data']
      return Task.new(attrs, snake_cased_json) if return_task
      return snake_cased_json
    end

    # task_id REQUIRED
    def self.find(task_id, return_task=false)
      url = "tasks/#{task_id}"
      resp = Manatoo.get(url)
      snake_cased_json = JSON.parse(resp.body).to_snake_keys
      attrs = snake_cased_json['data']
      return Task.new(attrs, snake_cased_json) if return_task
      return snake_cased_json
    end

    def initialize(data, snake_cased_json)
      @attributes = ATTRIBUTES_STRUCT.new
      set_attributes_from_hash(data)
      @last_json_response = snake_cased_json
      self
    end

    # task_id REQUIRED
    def self.update(task_id, attrs)
      url = "tasks/#{task_id}"
      resp = Manatoo.put(url, attrs)
      JSON.parse(resp.body).to_snake_keys
    end

    def update(attrs)
      snake_cased_json = Task.update(id, attrs)
      handle_snake_cased_json(snake_cased_json)
    end

    # task_id, status REQUIRED
    def self.update_status(task_id, status)
      url = "tasks/#{task_id}/status"
      resp = Manatoo.put(url, {
        status: status
      })
      JSON.parse(resp.body).to_snake_keys
    end

    def update_status(status)
      snake_cased_json = Task.update_status(id, status)
      handle_snake_cased_json(snake_cased_json)
    end

    # labels should not be empty, should be array
    def self.add_labels(task_id, labels)
      url = "tasks/#{task_id}/labels"
      resp = Manatoo.post(url, {
        labels: labels
      })
      JSON.parse(resp.body).to_snake_keys
    end

    def add_labels(labels)
      snake_cased_json = Task.add_labels(id, labels)
      handle_snake_cased_json(snake_cased_json)
    end

    # weight REQUIRED, should be integer
    def self.add_weight(task_id, weight)
      url = "tasks/#{task_id}/weight"
      resp = Manatoo.post(url, {
        weight: weight
      })
      JSON.parse(resp.body).to_snake_keys
    end

    def add_weight(weight)
      snake_cased_json = Task.add_weight(id, weight)
      handle_snake_cased_json(snake_cased_json)
    end

    # users should not be empty, should be array
    def self.add_users(task_id, users)
      url = "tasks/#{task_id}/users"
      resp = Manatoo.post(url, {
        users: users
      })
      JSON.parse(resp.body).to_snake_keys
    end

    def add_users(users)
      snake_cased_json = Task.add_users(id, weight)
      handle_snake_cased_json(snake_cased_json)
    end

    # users should not be empty, should be array
    def self.remove_users(task_id, users)
      url = "tasks/#{task_id}/users"
      resp = Manatoo.delete(url, {
        users: users
      })
      JSON.parse(resp.body).to_snake_keys
    end

    def remove_members(users)
      snake_cased_json = Task.remove_users(id, weight)
      handle_snake_cased_json(snake_cased_json)
    end
  end
end
