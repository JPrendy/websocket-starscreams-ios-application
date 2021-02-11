module.exports.botMessage = async ({ github, context }) => {
  commentBody="An example of text that can be outputted by Github script"
  // Get the existing comments.
  const { data: comments } = await github.issues.listComments({
    owner: context.repo.owner,
    repo: context.repo.repo,
    issue_number: context.payload.number,
  });
  // Find any comment already made by the bot.

  const botComment = await comments.find((comment) => comment.user.id);

  if (botComment) {
    return await github.issues.updateComment({
      owner: context.repo.owner,
      repo: context.repo.repo,
      comment_id: botComment.id,
      body: commentBody,
    });
  } else {
    return await github.issues.createComment({
      owner: context.repo.owner,
      repo: context.repo.repo,
      issue_number: context.payload.number,
      body: commentBody,
    });
  }
};

module.exports.botLabel = async ({ github, context }) => {
    return github.issues.addLabels({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        labels: ['bug']
      })
};