# documentation

### creating a class
```lua
myClass = class("ClassName", {})
-- second argument is optional
```

### creating an instance of a class
```lua
Person = class("Person")

function Person:walk()
  print("Walking!")
end

Me = Person()
```

#### adding constructor to a class
```lua
Person = class("Person", {
  name = nil, -- string
})

function Person:walk()
  print("Walking while yelling my name which is " .. self.name)
end

function Person:init(name) -- constructor!
  self.name = name
end

Me = Person("John Doe")
print(Me.name) --> john doe

Me:walk()
```
