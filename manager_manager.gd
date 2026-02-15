extends Node

#managermanager stores globals so that other nodes can easily 
#access other data from other nodes
#when the node is ready, it must set its variable in the managermanager
#very important: the manager must be at the top of the scene
var limits_manager: Node
