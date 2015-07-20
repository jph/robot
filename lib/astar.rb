# nodes = {}
# nodes[123] = { id: 123, linked_to: [456,678] }

class AStar
  def initialize(adjacency_func, cost_func, distance_func)
    @adjacency = adjacency_func
    @cost = cost_func
    @distance = distance_func
  end

  def find_path(start, goal, limit = 10_000)
    been_there = {}
    pqueue = PriorityQueue.new
    pqueue << [1, [start, [], 0]]
    while !pqueue.empty?
      spot, path_so_far, cost_so_far = pqueue.next
      next if been_there[spot]
      if been_there.size >= limit
        puts "not found after limit #{been_there.size}"
        return nil
      end
      newpath = path_so_far + [spot]
      if (spot == goal)
        puts "found after #{been_there.size}"
        return newpath
      end
      been_there[spot] = 1
      @adjacency.call(spot).each do |newspot|
        next if been_there[newspot]
        tcost = @cost.call(path_so_far, spot, newspot)
        next unless tcost
        newcost = cost_so_far + tcost
        pqueue << [newcost + @distance.call(path_so_far, goal, newspot),
                   [newspot, newpath, newcost]]
      end
    end
    puts "not found after #{been_there.size}"
    return nil
  end

  class PriorityQueue
    def initialize
      @list = []
    end
    def add(priority, item)
      @list << [priority, @list.length, item]
      @list.sort!
      self
    end
    def <<(pritem)
      add(*pritem)
    end
    def next
      @list.shift[2]
    end
    def empty?
      @list.empty?
    end
  end
end

# def a_star(start_id,end_id)
#   give_up_after = 1_000_000
#   attempts = 0

#   adjacency = lambda do |node_id|
#     attempts += 1
#     raise AStarGiveUpError if attempts > give_up_after
#     # puts "adjacency: #{node_id}"
#     nodes[node_id].linked_to
#   end

#   # extra distance costs for this node
#   cost = lambda do |path_so_far,node_id,next_id|
#     # puts "cost: #{node_id},#{next_id} - #{path_so_far.inspect}"
#     node, next_node = find_node(node_id), find_node(next_id)
#     cost = 1.0
#     cost * node_distance_3d(find_node(node_id),find_node(next_id)) * 0.33
#   end

#   # guess at remaining distance, must never be more than real distance for a* to be accurate
#   distance = lambda do |path_so_far,goal_id,dest_id|
#     # puts "distance: #{goal_id},#{dest_id}"
#     goal, dest = nodes[goal_id], nodes[dest_id]
#     # puts "goal: #{goal.inspect}, dest: #{dest.inspect}"
#     node_distance_3d(goal,dest)
#   end

#   begin
#     AStar.new(adjacency,cost,distance).find_path(start_id,end_id)
#   rescue AStarGiveUpError
#     nil
#   end
# end
