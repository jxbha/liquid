package pair

type Pair struct {
	Id   int
	Name string
	Val  string
}

func (p *Pair) IsValid() bool {
	return p.Name != "" && p.Val != ""
}

func NewPair(id int, name, val string) *Pair {
	return &Pair{Id: id, Name: name, Val: val}
}
