require 'spec_helper'

describe Dijkstra::Compute do
  describe 'Loading the graph file' do
    context 'when the input file does not exist' do
      it 'should raise an error' do
        expect { described_class.new(start: 'A', destination: 'B', file: 'foo') }.to raise_exception(ArgumentError, "Could not locate graph file foo.  Exiting.")
      end
    end

    context 'when the input file does exist' do
      it 'should not raise an error' do
        expect { described_class.new(start: 'A', destination: 'B', file: "#{File.dirname(__FILE__)}/data/looking_glass.txt") }.to_not raise_exception
      end
    end

    context 'when the input file is empty' do
      it 'should report that the start node is invalid' do
        expect { described_class.new(start: 'A', destination: 'B', file: "#{File.dirname(__FILE__)}/data/empty.txt") }.to raise_exception(ArgumentError, "The start node A is invalid. Should be one of []. Exiting")
      end
    end
  end

  describe '#check_params' do
    context 'when the start and destination are both in the graph' do
      it 'should not raise an error' do
        expect { described_class.new(start: 'A', destination: 'B', file: "#{File.dirname(__FILE__)}/data/looking_glass.txt") }.to_not raise_exception
      end
    end

    context 'when the start is not on the graph' do
      it 'should raise an error' do
        expect { described_class.new(start: 'Z', destination: 'B', file: "#{File.dirname(__FILE__)}/data/looking_glass.txt") }.to raise_exception(ArgumentError, "The start node Z is invalid. Should be one of [\"A\", \"B\", \"C\", \"D\", \"E\", \"F\", \"G\"]. Exiting")
      end
    end

    context 'when the end is not on the graph' do
      it 'should raise an error' do
        expect { described_class.new(start: 'A', destination: 'Z', file: "#{File.dirname(__FILE__)}/data/looking_glass.txt") }.to raise_exception(ArgumentError, "The destination node Z is invalid. Should be one of [\"A\", \"B\", \"C\", \"D\", \"E\", \"F\", \"G\"]. Exiting")
      end
    end
  end

  describe 'walking the line' do
    context 'when the start node is the destination node' do
      specify 'the best journey path should be the starting node and cost 0' do
        dijkstra = described_class.new(start: 'A',
                                       destination: 'A',
                                       file: "#{File.dirname(__FILE__)}/data/looking_glass.txt")
        expect(dijkstra.best_journey.cost).to eq(0)
        expect(dijkstra.best_journey.path).to match_array(['A'])
      end
    end

    context 'when there is no path to the destination node from the start node' do
      specify 'there should be no best journey' do
        dijkstra = described_class.new(start: 'A',
                                       destination: 'Z',
                                       file: "#{File.dirname(__FILE__)}/data/no_path.txt")
        expect(dijkstra.best_journey).to be_nil
      end
    end

    context 'when there is a path to the destination node from the start node' do
      specify 'it chooses the path with the least cost' do
        dijkstra = described_class.new(start: 'A',
                                       destination: 'G',
                                       file: "#{File.dirname(__FILE__)}/data/looking_glass.txt")
        expect(dijkstra.best_journey.cost).to eq(6)
        expect(dijkstra.best_journey.path).to match_array(%w(A B E G))
      end
    end

    context 'when there is a cycle in the graph' do
      specify 'it stops following the cyclic path and avoids an infinite loop' do
        dijkstra = described_class.new(start: 'A',
                                       destination: 'G',
                                       file: "#{File.dirname(__FILE__)}/data/cycle.txt")
        expect(dijkstra.best_journey.cost).to eq(6)
        expect(dijkstra.best_journey.path).to match_array(%w(A B E G))
      end
    end

    context 'when there is tie' do
      specify 'it chooses one of the lowest cost paths arbitrarily (first winner)' do
        dijkstra = described_class.new(start: 'A',
                                       destination: 'G',
                                       file: "#{File.dirname(__FILE__)}/data/tie.txt")
        expect(dijkstra.best_journey.cost).to eq(6)
      end
    end
  end
end


