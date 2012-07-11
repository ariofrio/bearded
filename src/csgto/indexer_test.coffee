Indexer = require './indexer'

describe 'Indexer', ->
  beforeEach -> @it = new Indexer

  it 'supports integers', ->
    @it.add(x) for x in [1, 2, 3, 1]
    @it.unique.should.eql [1, 2, 3]

  it 'supports strings', ->
    @it.add(x) for x in ['apple', 'banana', 'apple', 'orange']
    @it.unique.should.eql ['apple', 'banana', 'orange']

  it 'supports lists', ->
    @it.add(x) for x in [[1, 2], [3, 4], [1, 2], [3, 4], [4, 3]]
    @it.unique.should.eql [[1, 2], [3, 4], [4, 3]]
