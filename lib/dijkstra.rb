require_relative "dijkstra/version"

module Dijkstra
  class Compute
    attr_accessor :destination, :best_journey, :graph

    def initialize(start:, destination:, file:)
      self.graph = Graph.new(file)
      self.destination = destination

      check_params(start, destination)
      i_walk_the_line(Journey.new(path: [start], cost: 0))
      report_winner
    end

    private

    def i_walk_the_line(journey)
      return if journey.cycle?
      return if journey.loser?(best_journey)

      if journey.end?(destination)
        save_winner(journey) if journey.winner?(best_journey)
        return
      end

      graph.find(journey.path.last).connections.each do |connection|
        next_node, connection_cost = *connection
        new_cost = journey.cost + connection_cost
        i_walk_the_line(journey.take_a_step(node: next_node, cost: new_cost))
      end
    end

    def save_winner(journey)
      self.best_journey = journey
    end

    def report_winner
       puts(best_journey ? "Shortest path is [#{best_journey.path.join(',')}] with total cost #{best_journey.cost}" : "No winner found")
    end

    def check_params(start, destination)
      raise(ArgumentError, "The start node #{start} is invalid. Should be one of #{graph.ids}. Exiting") unless graph.find(start)
      raise(ArgumentError, "The destination node #{destination} is invalid. Should be one of #{graph.ids}. Exiting") unless graph.find(destination)
    end

  end

  class Graph
    attr_accessor :nodes

    def initialize(file)
      raise(ArgumentError, "Could not locate graph file #{file}.  Exiting.") unless File.exists?(file)
      self.nodes = Hash.new

      File.foreach(file) do |record|
        clean_node_record!(record)
        next if record.empty?
        from, to, cost = record.split(',')
        from = find_or_create(from)
        to   = find_or_create(to)
        add_connection(from: from, to: to, cost: cost.to_i)
      end
    end

    def clean_node_record!(record)
      record.gsub!(/[\[\]\s]/, '')
    end

    def add_node(node)
      nodes[node.id] = node
    end

    def add_connection(from:, to:, cost:)
      from.connections << [to.id, cost]
    end

    def find_or_create(id)
      find(id) || add_node(Node.new(id))
    end

    def find(id)
      nodes[id]
    end

    def ids
      nodes.keys
    end
  end

  class Node
    attr_accessor :connections, :id

    def initialize(id)
      @id = id
      @connections = []
    end
  end

  class Journey
    attr_accessor :path, :cost

    def initialize(path:, cost:)
      @path = path # array of ids
      @cost = cost # int
    end

    def take_a_step(node:, cost:)
      nxt = self.dup
      nxt.path = path.dup.push node
      nxt.cost = cost
      nxt
    end

    def end?(destination)
      path.last == destination
    end

    def cycle?
      # So bad data doesn't crash the program
      path.length != path.uniq.length
    end

    def winner?(other_journey)
      return true if other_journey.nil?
      cost < other_journey.cost
    end

    def loser?(other_journey)
      !winner?(other_journey)
    end
  end
end
