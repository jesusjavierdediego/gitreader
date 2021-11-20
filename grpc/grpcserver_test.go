package grpc

import (
	"testing"
	"time"
	. "github.com/smartystreets/goconvey/convey"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"strconv"
	"log"
	pb "xqledger/gitreader/protobuf"
)

const filename = "100.json"
const reponame = "GitOperatorTestRepo"
const oldcommit = "009ad0734ea8727e6a1064663a8b901ad5f47272"
const newcommit = "6836a89827c310a3ae7e431fedba9ca62252e5be"

func getRecordHistoryServiceConn() (*grpc.ClientConn, error) {
	var address = "localhost:" + strconv.Itoa(config.GrpcServer.Port)
	var conn *grpc.ClientConn
	var connErr error
	conn, connErr = grpc.Dial(address, grpc.WithInsecure())
	if connErr != nil {
		log.Fatalf("did not connect: %v", connErr)
		return nil, connErr
	}
	return conn, nil
}

func TestRecordHistoryService(t *testing.T) {
	conn, _ := getRecordHistoryServiceConn()
	defer conn.Close()
	c := pb.NewRecordHistoryServiceClient(conn)
	var commit = ""
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	Convey("Should GetRecordHistory", t, func() {
		conn, _ := getRecordHistoryServiceConn()
		defer conn.Close()
		c := pb.NewRecordHistoryServiceClient(conn)

		query := &pb.Query{
			CommitIdOld: "",
			CommitIdNew: "",
			FilePath: filename,
			RepoName: reponame,
		}
		result, err := c.GetRecordHistory(ctx, query)
		if len(result.Commits) > 0 {
			commit = result.Commits[0].Hash
		}
		So(err, ShouldBeNil)
		So(len(result.Commits), ShouldBeGreaterThan, 0)
	})

	Convey("Should GetContentInCommit", t, func() {
		query := &pb.Query{
			CommitIdOld: commit,
			CommitIdNew: "",
			FilePath: filename,
			RepoName: reponame,
		}
		_, err := c.GetContentInCommit(ctx, query)
		So(err, ShouldBeNil)
	})

	Convey("Should GetDiffTwoCommitsInFile", t, func() {
		query := &pb.Query{
			CommitIdOld: commit,
			CommitIdNew: commit,
			FilePath: filename,
			RepoName: reponame,
		}
		_, err := c.GetDiffTwoCommitsInFile(ctx, query)
		So(err, ShouldBeNil)
	})
}