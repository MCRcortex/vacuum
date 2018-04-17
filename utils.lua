tasks={}
function whileLoop(isDone,task)-- USE TO ADD WHILE LOOP
	
	table.insert(tasks,{isDone=isDone,task=task})
end
function whileLoopWrapper()
	for _,i in pairs(tasks) do
		if(i.isDone()) then table.remove(tasks,_) else i.task() end
	end
end

script.on_event({defines.events.on_tick},whileLoopWrapper)