package config

import (
	"fmt"

	"github.com/therecipe/qt/core"
)

// Model Roles
const (
	ID = int(core.Qt__UserRole) + 1<<iota
	Location
	Instances
	Maphack
	HD
)

// GameModel ...
type GameModel struct {
	core.QAbstractListModel

	_ func() `constructor:"init"`

	_ map[int]*core.QByteArray `property:"roles"`
	_ []*Game                  `property:"games"`

	_ func(*Game) `slot:"addGame"`
}

func (m *GameModel) init() {
	m.SetRoles(map[int]*core.QByteArray{
		ID:        core.NewQByteArray2("id", -1),
		Location:  core.NewQByteArray2("location", -1),
		Instances: core.NewQByteArray2("instances", -1),
		Maphack:   core.NewQByteArray2("maphack", -1),
		HD:        core.NewQByteArray2("hd", -1),
	})

	m.ConnectData(m.data)
	m.ConnectRowCount(m.rowCount)
	m.ConnectColumnCount(m.columnCount)
	m.ConnectRoleNames(m.roleNames)
	m.ConnectAddGame(m.addGame)
}

func (m *GameModel) rowCount(*core.QModelIndex) int {
	return len(m.Games())
}

func (m *GameModel) columnCount(*core.QModelIndex) int {
	return 1
}

func (m *GameModel) roleNames() map[int]*core.QByteArray {
	return m.Roles()
}

func (m *GameModel) data(index *core.QModelIndex, role int) *core.QVariant {
	if !index.IsValid() {
		return core.NewQVariant()
	}

	if index.Row() >= len(m.Games()) {
		return core.NewQVariant()
	}

	item := m.Games()[index.Row()]

	switch role {
	case ID:
		return core.NewQVariant1(item.ID)
	case Location:
		return core.NewQVariant1(item.Location)
	case Instances:
		return core.NewQVariant1(item.Instances)
	case Maphack:
		return core.NewQVariant1(item.Maphack)
	case HD:
		return core.NewQVariant1(item.HD)
	default:
		return core.NewQVariant()
	}
}

// addGame adds a character to the model.
func (m *GameModel) addGame(g *Game) {
	m.BeginInsertRows(core.NewQModelIndex(), len(m.Games()), len(m.Games()))
	m.SetGames(append(m.Games(), g))
	m.EndInsertRows()
}

// updateGame updates the game at the given index.
func (m *GameModel) updateGame(id int) {
	games := m.Games()
	for i := 0; i < len(games); i++ {
		fmt.Println("COMPARING", games[i].ID, id)
		if games[i].ID == id {
			fmt.Println("FOUND ITEM TO UDPATE")
			games[i].Location = "derp"
		}
	}

	var fIndex = m.Index(0, 0, core.NewQModelIndex())
	var lIndex = m.Index(len(games)-1, 0, core.NewQModelIndex())
	m.DataChanged(fIndex, lIndex, []int{Location})
}

func init() {
	GameModel_QRegisterMetaType()
	Game_QRegisterMetaType()
}
