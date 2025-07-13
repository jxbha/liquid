package pair

// should this really be here? should this be its own package / factory?
type Pair struct {
	Id   int
	Name string
	Val  string
}

func (p *Pair) IsValid() bool {
	return p.Name != "" && p.Val != ""
}
