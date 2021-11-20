package askgit

import (
	"strings"
	"testing"
	. "github.com/smartystreets/goconvey/convey"
)

func TestClone(t *testing.T) {
	Convey("Check cloning git repo ", t, func() {
		reponame := "GitOperatorTestRepo"
		remoteRepoURL := config.Gitserver.Url + "/" + config.Gitserver.Username + "/" + reponame
		repoPath, _ := getLocalRepoPath(reponame)
		err := Clone(remoteRepoURL, repoPath)
		if strings.Contains(err.Error(), "repository already exists") {
			err = nil
		}
		So(err, ShouldBeNil)
	})
}
