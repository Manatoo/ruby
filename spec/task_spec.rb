require 'spec_helper'
require 'manatoo'

describe Manatoo::Task do
  before do
    Manatoo.api_key = ENV['API_KEY']
    @list_id = ENV['LIST_ID']
  end

  describe 'task' do

    context 'when updating a created task' do
      task_title = "Check the sales data on Product X"
      task_description = "Pull out sales data from April"
      task_weight = 10
      # TODO: test users logic, this is hard because the users
      # must be members of the list to be added
      task_users = ["john@example.com", "PJwjWbo0thle"]
      task_labels = ["sales", "urgent"]
      task_due_at = "2018-02-24T18:02:59.521Z"
      task_data = {
        'month' => 'April',
        'region' => 'us-west'
      }

      before(:all) do
        @task_ids = []
      end

      it 'creates a task' do
        task = Manatoo::Task.create({
          list_id: @list_id,
          title: task_title,
          description: task_description,
          due_at: task_due_at,
          weight: task_weight,
          labels: task_labels,
          data: task_data,
        }, true)
        @task_ids.push(task.id)

        expect(task.id).to_not           be_nil
        expect(task.title).to            eq(task_title)
        expect(task.description).to      eq(task_description)
        expect(task.status).to           eq('open') # should default to 'open'
        expect(task.due_at).to           eq(task_due_at)
        expect(task.weight).to           eq(task_weight)
        expect(task.labels.sort.join).to eq(task_labels.sort.join)
        expect(task.data.sort.to_s).to   eq(task_data.sort.to_s)
      end

      it 'updates the description' do
        task_id = @task_ids.first
        task = Manatoo::Task.find(task_id, true)
        expect(task.id).to          eq(task_id)
        expect(task.description).to eq(task_description)

        new_task_description = 'The quick brown fox jumps over the lazy dog'
        task.update({
          description: new_task_description,
        })
        expect(task.description).to eq(new_task_description)
      end

      it 'updates only the status' do
        task_id = @task_ids.first
        task = Manatoo::Task.find(task_id, true)
        expect(task.id).to     eq(task_id)
        expect(task.status).to eq('open')

        task.update_status('finished')
        expect(task.status).to eq('finished')
      end

      it 'adds labels' do
        task_id = @task_ids.first
        task = Manatoo::Task.find(task_id, true)
        expect(task.id).to               eq(task_id)
        expect(task.labels.sort.join).to eq(task_labels.sort.join)

        labels_to_add = ['brown', 'fox']
        task.add_labels(labels_to_add)
        expect(task.labels.sort.join).to eq((task_labels + labels_to_add).sort.join)
      end

      it 'adds weight' do
        task_id = @task_ids.first
        task = Manatoo::Task.find(task_id, true)
        expect(task.id).to     eq(task_id)
        expect(task.weight).to eq(task_weight)

        weight_to_add = 5
        task.add_weight(weight_to_add)
        expect(task.weight).to eq(task_weight + weight_to_add)
      end
    end
  end
end
