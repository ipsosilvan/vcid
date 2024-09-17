from flask import jsonify, request, url_for
from app.models import Post
from app.api import bp
from app import db
from flask_httpauth import HTTPTokenAuth
from app.models import User

auth = HTTPTokenAuth()

@auth.verify_token
def verify_token(token):
    return User.check_token(token) if token else None

# GET: Alle Posts abrufen
@bp.route('/posts', methods=['GET'])
def get_posts():
    posts = Post.query.all()
    return jsonify([post.to_dict() for post in posts])

# POST: Neuen Post erstellen
@bp.route('/posts', methods=['POST'])
@auth.login_required
def create_post():
    data = request.get_json() or {}
    if 'body' not in data:
        return jsonify({'error': 'Post body is required'}), 400
    post = Post(body=data['body'], author=auth.current_user())
    db.session.add(post)
    db.session.commit()
    return jsonify(post.to_dict()), 201

# DELETE: Post löschen
@bp.route('/posts/<int:id>', methods=['DELETE'])
@auth.login_required
def delete_post(id):
    post = Post.query.get_or_404(id)
    if post.author != auth.current_user():
        return jsonify({'error': 'Unauthorized access'}), 403
    db.session.delete(post)
    db.session.commit()
    return '', 204