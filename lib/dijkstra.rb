require_relative "dijkstra/version"

module Dijkstra
  class Node
    attr_accessor :connections, :id

    def initialize(id)
      @id = id
      @connections = []
      self.class.add_node(self)
    end

    class << self
      def djikstra(start:, destination:, file:)
        reset
        load_graph(file)
        self.destination = find(destination)
        i_walk_the_line(current: find(start), path: [start])
        report_winner
      end

      def add_node(node)
        nodes[node.id] = node
      end

      def all
        nodes.each_pair do |id, node|
          puts "node: #{id} connections #{node.connections}"
        end
        nil
      end

      private

      attr_accessor :nodes, :best_cost, :best_path, :destination

      def add_connection(from:, to:, cost:)
        from.connections << [to.id, cost]
      end

      def find_or_create(id)
        find(id) || new(id)
      end

      def find(id)
        nodes[id]
      end

      def load_graph(file)
        File.foreach(file) do |record|
          clean_node_record!(record)
          next if record.empty?
          from, to, cost = record.split(',')
          add_connection(from: find_or_create(from.to_sym),
                         to:   find_or_create(to.to_sym),
                         cost: cost.to_i)
        end
        nil
      end

      def clean_node_record!(record)
        record.gsub!(/[\[\]\s]/,'')
      end

      def i_walk_the_line(current:, path:, cost: 0)

        return if cycle?(node: current, path: path)
        return if loser?(cost)

        if end?(current)
          save_winner(cost: cost, path: path) if winner?(cost)
          return
        end

        current.connections.each do |connection|
          next_node, connection_cost = *connection
          new_cost = cost + connection_cost
          i_walk_the_line(current: find(next_node),
                          path: path.dup.push(next_node),
                          cost: new_cost)
        end
      end

      def report_winner
        if best_path
          puts("Shortest path is [#{best_path.join(',')}] with total cost #{best_cost}")
        else
          puts("No winner found")
        end
      end

      def save_winner(cost:, path:)
        self.best_cost = cost
        self.best_path = path
      end

      def winner?(cost)
        best_cost.nil? || (cost < best_cost)
      end

      def loser?(cost)
        !winner?(cost)
      end

      def end?(current)
        current == destination
      end

      def cycle?(node:, path:)
        path.length.zero? ? false : path.first(path.length - 1).include?(node.id)
      end

      def reset
        self.best_cost = nil
        self.best_path = nil
        self.nodes = Hash.new
      end
    end
  end
end
