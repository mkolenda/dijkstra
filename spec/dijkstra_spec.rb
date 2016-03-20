require 'spec_helper'

describe Dijkstra::Node do
  let(:node_a) {instance_double 'Dijkstra::Node', id: 'A'}
  let(:node_b) {instance_double 'Dijkstra::Node', id: 'B'}

  after do
    Dijkstra::Node.send(:reset)
  end

  it 'has a version number' do
    expect(Dijkstra::VERSION).not_to be nil
  end

  describe 'instance methods' do
    let(:node) { Dijkstra::Node.new('A') }

    describe '#initialize' do
      it 'should store the id' do
        expect(node.id).to eq('A')
      end

      it 'should have an empty array of connections' do
        expect(node.connections).to eq([])
      end

      it "should tell it's class that it is on the scene" do
        expect(described_class).to receive(:add_node)
        node
      end

      specify "the class should have a record of the node's existence" do
        node
        expect(described_class.ids).to eq([node.id])
      end
    end
  end

  describe 'class methods' do
    describe '#add_node, #ids' do

      before do
        described_class.add_node(node_a)
        described_class.add_node(node_b)
      end
      it 'should add the node to the class' do
        expect(described_class.ids).to eq([node_a.id, node_b.id])
      end
    end

    describe '#load_graph' do
      describe 'when the input file does not exist' do
        it 'should raise an error' do
          expect { described_class.send(:load_graph, 'foo' )}.to raise_exception(ArgumentError, "Could not locate graph file foo.  Exiting.")
        end
      end

      describe 'when the input file does exist' do
        it 'should not raise an error' do
          expect { described_class.send(:load_graph, "#{File.dirname(__FILE__)}/data/looking_glass.txt")}.to_not raise_exception
        end
      end
    end

    describe '#check_params' do
      describe 'when the start and destination are both in the graph' do
        before do
          described_class.add_node(node_a)
          described_class.add_node(node_b)
        end

        it 'should not raise an error' do
          expect { described_class.send(:check_params, node_a.id, node_b.id) }.to_not raise_exception
        end
      end

      describe 'when the start is not on the graph' do
        before do
          described_class.add_node(node_b)
        end

        it 'should raise an error' do
          expect { described_class.send(:check_params, node_a.id, node_b.id) }.to raise_exception(ArgumentError, "The start node A is invalid. Should be one of [\"B\"]. Exiting")
        end

      end

      describe 'when the end is not on the graph' do
        before do
          described_class.add_node(node_a)
        end

        it 'should raise an error' do
          expect { described_class.send(:check_params, node_a.id, node_b.id) }.to raise_exception(ArgumentError, "The destination node B is invalid. Should be one of [\"A\"]. Exiting")
        end

      end
    end

  end

  # 2.2.3 :019 > Dijkstra::Node.djikstra(start: "A", destination: "A", file: '/Users/mateo/RubymineProjects/untitled1/source2.txt')
  # Shortest path is [A] with total cost 0

end


